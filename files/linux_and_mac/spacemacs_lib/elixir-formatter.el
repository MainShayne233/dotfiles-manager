;;; elixir formatter

;; Maintainer: @jasongoodwin

;; This package will expose commands to call out to mix to format your project for you.
;; Requires elixir 1.6
;; Note you may need to start emacs from the shell to have the proper environment. mix/elixir appear to depend on many unix utilities.

;;; Code:

(defcustom
  mix-location
  "/usr/local/bin/mix"
  "Location of mix binary (must be elixir 1.6 or later)"
  :type 'string
  :group 'mix-format
  )

(defcustom
  elixir-location
  "/usr/local/bin/elixir"
  "Location of elixir binary (must be elixir 1.6 or later)"
  :type 'string
  :group 'mix-format
  )

(defun
    elixir-format-current-file
    ()
  "Saves the file and then calls out to mix to format the code."
  (interactive)
  (save-buffer)
  (defvar current-file (buffer-file-name))
  (shell-command (concat elixir-location " " mix-location " format " current-file)))


