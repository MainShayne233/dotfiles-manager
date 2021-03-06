(defun selected-text () 
  "Returns the currently selected text" 
  (buffer-substring 
   (region-beginning) 
   (region-end)))

(defun region-regexp-replace (match-pattern replace-pattern) 
  "Runs a replace-regexp-in-string on currently selected region"
  (let ((updated-region (replace-regexp-in-string match-pattern replace-pattern (selected-text)))) 
    (delete-region (region-beginning) 
                   (region-end)) 
    (insert updated-region)))


(defun valid-elixir-key-regex () 
  "A regex pattern for a valid Elixir key"
  "[A-z|0-9|\\@]+[\\?|\\!]?")

(defun elixir-string-key-match () 
  "Pattern for match on an Elixir string key"
  (concat "\"\\(" (valid-elixir-key-regex) "\\)\" =>"))

(defun elixir-string-key-replace () 
  "Pattern for replacing an Elixir key with a string key"
  "\"\\1\" =>")

(defun elixir-atom-key-match () 
  "Pattern for match on an Elixir atom key"
  (concat "\\(" (valid-elixir-key-regex) "\\):"))

(defun elixir-atom-key-replace () 
  "Pattern for replacing an Elixir key with a atom key"
  "\\1:")


(defun elixir-string-to-atom-keys () 
  "Select the body of an Elixir map w/ string keys, and this will convert them to atom keys" 
  (interactive) 
  (if (use-region-p) 
      (region-regexp-replace (elixir-string-key-match) 
                             (elixir-atom-key-replace))))

(defun elixir-atom-to-string-keys () 
  "Select the body of an Elixir map w/ atom keys, and this will convert them to string keys" 
  (interactive) 
  (if (use-region-p) 
      (region-regexp-replace  (elixir-atom-key-match) 
                              (elixir-string-key-replace))))
