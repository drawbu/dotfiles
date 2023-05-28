from typing import Final

from libqtile.config import Group, Key, ScratchPad, DropDown
from libqtile.lazy import lazy

from .keys import keys, META, TERMINAL

groups = [Group(i) for i in "azerty"]
DROPDOWN_TERM: Final[str] = "term"

for group in groups:
    keys.append(
        Key(
            [META, "shift"],
            group.name,
            lazy.group[group.name].toscreen(),
            desc="Switch to group {}".format(group.name),
        ),
    )

groups.append(
    ScratchPad(
        "scratchpad",
        [DropDown(DROPDOWN_TERM, TERMINAL, x=0.05, y=0.05, opacity=1.0, height=0.9, width=0.9)]
    )
)
keys.append(
    Key(
        [META],
        "space",
        lazy.group["scratchpad"].dropdown_toggle(DROPDOWN_TERM)
    )
)
