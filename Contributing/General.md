# Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit
helps, and credit will always be given.

The owners of this project focus on Red Hat Enterprise Linux (and related
distros &mdash; Alma, Rocky, CentOS Stream, Oracle and even Amazon Linux 2023)
and Windows Server. As of the time of this document's writing, Linux efforts
are centered around EL9 and Windows Server 2022. If functionality is desired
for other operating systems (e.g., Ubuntu, OSX, etc.), it will likely be
necessary for this project's current or futur user-community to contribute that
content.

## Bug Reports

When reporting a bug please include:

*   Your operating system name and version.
*   Your deployment environment (e.g., AWS, Azure, etc.)
    *   If your deployment-environment is (public or restricted/isolated)
        cloud-hosted:
        *   List the CSP
        *   List the CSP's region &mdash; or equivalent &mdash; the issue is
            encountered within
        *   List the instance-type(s) &mdash; or equivalent &mdash; the issue is
            encountered on[^1]
    *   If your deployment-environment is self-hosted (i.e., "on premises"):
        *   Provide a detailed description of the hosting hardware
        *   Provide a detailed description of how your OS is built (e.g.,
            kickstart profiles, VMware templates, etc) and configured (e.g.,
            Ansible playbooks or equivalent, etc.)
        *   If environment doesn't allow unfettered access to the public
            Internet, provide a detailed description of networking topologies
*   Any details about your local setup that might be helpful in troubleshooting.
*   Detailed steps to reproduce the bug.

## Documentation Improvements

This project could always use more documentation, whether as part of the
official project-docs, in programs' docstrings, SaltStack files' comments or
embedded Jinja or even on the web in blog posts, articles, and the lik. The
official documentation is maintained within this project in docstrings or (in
the future) in the "docs" directory. Contributions are welcome, and are made
the same way as any other code.

## Feature Requests and Feedback

The best way to send feedback is to file an issue on this project's GitHub
issues page.

If you are proposing a feature[^2]:

*   Provide a descriptive title to the Issue and prepend the title with the
    string, `[FEATURE]` or `[ENHANCEMENT]`
*   Explain in detail how it would work.
*   Keep the scope as narrow as possible, to make it easier to implement.
*   Remember that this is a community-driven, open-source project, and that
    code contributions are welcome.

If providing feadback:

*   Clearly indicate whether the feedback is for functionality, documentation or
    code-level comments/doc-strings
*   If requesting changes to project contents, open an issue. Like the above
    "proposing a feature":
    *   Provide a descriptive title to the Issue and prepend the title with the
        string `[DOCUMENTATION]`
    *   Explain in detail the changes you would like to see made and why you
        think they should be made
    *   Remember that this is a community-driven, open-source project, and that
        code contributions are welcome.


[^1]: Please provide a link to the CSP's documents for any relevant instance-type information
[^2]: Bearing in mind that requests for automation-coverage beyond Windows or Enterprise Linux will likely be "self-help"
