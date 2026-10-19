#!/usr/bin/env python3
"""Talks to the QEMU guest agent (qemu-guest-agent) of a running test VM.

    qga.py <socket> ping                 exits 0 when the agent answers
    qga.py <socket> shutdown             powers the guest off
    qga.py <socket> exec <command>       runs it with /bin/sh -c in the guest,
                                         as root; prints its stdout/stderr and
                                         exits with its exit code
"""

import base64
import json
import socket
import sys
import time


class Agent:
    def __init__(self, path):
        s = socket.socket(socket.AF_UNIX)
        s.settimeout(10)
        s.connect(path)
        self.f = s.makefile("rw")

    def send(self, command, **arguments):
        message = {"execute": command}
        if arguments:
            message["arguments"] = arguments
        self.f.write(json.dumps(message) + "\n")
        self.f.flush()

    def call(self, command, **arguments):
        self.send(command, **arguments)
        return json.loads(self.f.readline())["return"]


def guest_exec(agent, command):
    # Drops any stale reply left in the channel by an earlier client
    agent.call("guest-sync", id=4242)
    pid = agent.call("guest-exec", path="/bin/sh", arg=["-c", command],
                     **{"capture-output": True})["pid"]
    while not (status := agent.call("guest-exec-status", pid=pid))["exited"]:
        time.sleep(0.5)
    sys.stdout.buffer.write(base64.b64decode(status.get("out-data", "")))
    sys.stderr.buffer.write(base64.b64decode(status.get("err-data", "")))
    return status.get("exitcode", 1)


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    path, action, rest = sys.argv[1], sys.argv[2], sys.argv[3:]
    agent = Agent(path)
    if action == "ping" and not rest:
        agent.call("guest-ping")
    elif action == "shutdown" and not rest:
        agent.call("guest-ping")
        agent.send("guest-shutdown")  # no reply on success
    elif action == "exec" and len(rest) == 1:
        sys.exit(guest_exec(agent, rest[0]))
    else:
        sys.exit(__doc__)


if __name__ == "__main__":
    main()
