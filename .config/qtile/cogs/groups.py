from libqtile.config import Group, Key
from libqtile.lazy import lazy

from .keys import keys, META


terminal = "kitty"
groups = [Group(i) for i in "azerty"]


for group in groups:
    keys.append(
        Key(
            [META, "shift"],
            group.name,
            lazy.group[group.name].toscreen(),
            desc="Switch to group {}".format(group.name),
        ),
    )
