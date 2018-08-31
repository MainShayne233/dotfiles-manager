;; Allows `M-f` to run the correct code formatter for the current buffer
;;
;; Currently supports:
;;   - `prettier`: for .js and .jsx files
;;   - `mix format`: for .ex and .exs files
;;
;; `prettier` support required a locally installed version of `prettier`


(defun shell-command-on-region-to-string (start end command)
  "Runs a shell command and returns the output as a string"
  (save-window-excursion
    (with-output-to-string
      (shell-command-on-region start end command standard-output))))

(defun shell-command-on-region-to-buffer (start end command)
  "Runs a shell command and replaces the current buffer with the output"
  (interactive)
  (setq pos (point))
  (setf (buffer-string) (shell-command-on-region-to-string start end command))
  (goto-char pos))

(defun prettier-command ()
  "Constructs the path to a locally installed version of `prettier`"
  (concat (projectile-project-root) "node_modules/.bin/prettier")
)

(defun run-prettier ()
  "Runs `prettier` on the current buffer"
  (interactive)
  (prettier-js-mode)
  (prettier-js)
;;  (shell-command-on-region-to-buffer (point-min) (point-max) (prettier-command))
)

(defun current-file-extension ()
  "Returns the extension of the file for the current buffer"
  (interactive)
  (file-name-extension buffer-file-name)
)

(defun in-javascript-file ()
  "Determines whether or not the current file is a JavaScript file"
  (interactive)
  (or (string= (current-file-extension) "js") (string= (current-file-extension) "jsx")
      (string= (current-file-extension) "tsx")
      )
)

(defun in-elixir-file ()
  "Determines whether or not the current file is an Elixir file"
  (interactive)
  (or (string= (current-file-extension) "ex") (string= (current-file-extension) "exs"))
)

(defun in-elm-file ()
  "Determines whether or not the current file is an Elm file"
  (interactive)
  (string= (current-file-extension) "elm")
)

(defun format-buffer ()
  "Runs the correct formatter for the current file"
  (interactive)
  (cond ((in-javascript-file) (run-prettier))
        ((in-elixir-file) (elixir-format))
  )
)

(global-set-key (kbd "M-f") 'format-buffer)
