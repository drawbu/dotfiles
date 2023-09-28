from typing import Final

from libqtile.config import Group, Key, ScratchPad, DropDown
from libqtile.lazy import lazy

from utils import META, TERMINAL
from .keys import keys


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


@lazy.function
def focus_previous_group(qtile):
    current = qtile.current_screen.group
    previous_group = current.get_previous_group()
    qtile.current_screen.set_group(previous_group)


@lazy.function
def focus_next_group(qtile):
    current = qtile.current_screen.group
    next_group = current.get_next_group()
    qtile.current_screen.set_group(next_group)


keys.extend(
    [
        Key(
            [META, "shift"],
            "h",
            focus_previous_group,
        ),
        Key(
            [META, "shift"],
            "l",
            focus_next_group,
        ),
    ]
)


groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                DROPDOWN_TERM,
                TERMINAL,
                x=0.05,
                y=0.05,
                opacity=1.0,
                height=0.9,
                width=0.9,
                on_focus_lost_hide=False,
            )
        ],
    )
)
keys.append(
    Key([META], "space", lazy.group["scratchpad"].dropdown_toggle(DROPDOWN_TERM))
)
