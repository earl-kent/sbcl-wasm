

(in-package :sbcl-wasm)

(defun set-var! (var val env)
  "Set a variable to a value, in the given or global environment."
  (if (assoc var env)
      (setf (second (assoc var env)) val)
      (set-global-var! var val))
  val)

(defun get-var (var env)
  "Get the value of a variable, from the given or global environment."
    (if (assoc var env)
        (second (assoc var env))
        (get-global-var var)))


(defvar *global-vals* (gensym))


(defun set-global-var! (var val)
  (setf (get *global-vals* var) val))

(defun get-global-var (var)
  (let* ((default "unbound")
         (val (get *global-vals* var default)))
    (if (eq val default)
        (error "Unbound scheme variable: ~a" var)
        val)))
