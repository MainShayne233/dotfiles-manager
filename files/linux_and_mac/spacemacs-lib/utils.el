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

(defun elixir-string-to-atom-keys () 
  "Select the body of an Elixir map w/ string keys, and this will convert them to atom keys" 
  (interactive) 
  (if (use-region-p) 
      (region-regexp-replace "\"\\(.+\\)\" =>" "\\1:")))

(defun elixir-atom-to-string-keys () 
  "Select the body of an Elixir map w/ atom keys, and this will convert them to string keys" 
  (interactive) 
  (if (use-region-p) 
      (region-regexp-replace "\\(\\w+\\):" "\"\\1\" =>")))
