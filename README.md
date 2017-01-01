# El mock

_NOTE: El mock has moved from
<http://www.emacswiki.org/emacs/el-mock.el> to
<https://github.com/rejeep/el-mock.el> and its new maintainer is
[@rejeep](https://github.com/rejeep)._

El mock is a mocking library for Emacs. 

## How to use it
Add this to your test-helper, [for instance](https://github.com/rejeep/prodigy.el/blob/700eb15293260fdfa2fc0cff38df600693b7e4e5/test/test-helper.el#L107-L109)
```
(require 'el-mock)
(eval-when-compile
    (require 'cl)) ;; for el-mock
```

An example of a simple mock that displays "/mocked/file/name.el":
```
(with-mock
  (stub buffer-file-name => "/mocked/file/name.el")
  (display-message-or-buffer (buffer-file-name)))
```

## Documentation

Find the documentation at `M-x describe-function RET with-mock RET`
and `M-x describe-function RET mocklet RET`.

The old documentation is at https://www.emacswiki.org/emacs/EmacsLispMock


## Contribution

Be sure to!

Install [Cask](https://github.com/cask/cask) if you haven't already.

Run the unit tests with:

    $ make test
