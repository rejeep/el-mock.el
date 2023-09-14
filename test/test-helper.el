;; -*- lexical-binding: t; -*-

(require 'f)
(require 'ert-expectations)

(require 'undercover)
(undercover "*.el" "el-mock/*.el"
            (:exclude "*-test.el")
            (:report-format 'lcov)
            (:send-report nil))
(require 'el-mock (f-expand "el-mock.el" (f-parent (f-parent (f-this-file)))))
