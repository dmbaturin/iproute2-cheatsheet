Task-centered iproute2 manual
=============================

The `ip` command from the iproute2 package is now **the** Linux network management tool.
Not only it combines the functionality of the old `ifconfig`, `vconfig` etc. commands,
it also supports networking features that old commands never supported and still
don't support, such as multiple addresses on the same interface, network namespaces,
policy-based routing and so on.

One problem with the iproute2 package though is that its man pages offer only very brief
descriptions of its options and don't provide any examples, so they are only good as reminders
for experienced users. Many people keep using `ifconfig` not just out of habit, but also because
they may not even know what they are missing out.

The problem was historically solved by community-maintained documentation such as
http://policyrouting.org/iproute2-toc.html and https://www.lartc.org/howto/
Most of those documents have not been actively expanded since early or mid 2000's though,
and do not cover any new features. They are also under non-free licenses that make
them very hard to fork and maintain in case the original maintainers lose interest
in maintaining them.

This document aims to provide a comprehensive, easy to use, and free an open source
guide to iproute2 where network admins can quickly look up how to solve a particular
problem with the `ip` command, for example add/remove an address, create a routing table,
create a network namespace and so on.

Originally it was named "iproute2 cheatsheet", but was renamed to "Task-centered iproute2 manual"
due to vastly increased size and scope.


# Primary location and mirroring

The original and primary location of the document is https://baturin.org/docs/iproute2/

The page is bundled with all the JS and CSS it needs, so it's easy to mirror.
If you decide to mirror it, please make sure to update it automatically from git to avoid
creating outdated copies.

# Contributing

Patches are always welcome. If you want to fix a typo, improve grammar or wording,
or document a previously undocumented feature, please open a pull request or email me
a patch (use git format-patch please).

The document is licensed under CC-BY-SA.
