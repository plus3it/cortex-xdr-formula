# Setup for New Features and Bug Reproduction and Remediation

## Prototyping and Testing

When new features are added to or a bug has been reported against this project,
(manual) end-to-end testing and diagnostics are performed. This project's
contents are tested using:

*   New features or bug-testing for Windows Server: The base testing
    configurations are built using the Amazon Machine Images (AMIs) for Windows
    Server.
*   New features or bug-testing for Enterprise Linux distros: The base testing
    configurations are built using the spel[^1] Amazon Machine Images (AMIs) for
    Enterprise Linux 9. Generally, one of Rocky or Alma Linux will be used.

Whether Windows- or Linux-based, prototyping- and/or debugging-related
activities will be done on hardened targets. The default hardening-target are
the DISA STIGs. If reporting a bug triggered under a different
hardening-target, it will be necessary for the reporter to detail the
hardening-type and provide guidance for achieving the same while using the
previously described Windows or Linux environment.

## Environments Note

Testing geared towards adding new functionality or to reproduce/diagnose bugs
for remediation will generally be done in an AWS Commercial region. Use of AWS
GovCloud or other regions is case-by-case and will rely on the bug-reporter's
ability to prove that the issue _only_ occurs in a given, non-commercial
region-type. Ability to perform bug-reproduction in other environments is
extremely limited for this project's maintainers. If reporting a bug that only
occurs in other-than-AWS environments, reporters should be prepared to do
requested diagnostic tasks in their own environments if the issue can only be
produced in those environments.


[^1]: See the [spel](https://github.com/plus3it/spel) project's [Current Published Images](https://github.com/plus3it/spel?tab=readme-ov-file#current-published-images) section
