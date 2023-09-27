import subprocess
from typing import List


def get_stdout(cmd: List[str], timeout: int = 1) -> str:
    try:
        sub = subprocess.run(cmd, stdout=subprocess.PIPE, timeout=timeout)
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return ""
    return sub.stdout.decode("utf-8").strip()
