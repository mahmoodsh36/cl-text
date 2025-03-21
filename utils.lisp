(in-package :cltpt)

(setf lparallel:*kernel* (lparallel:make-kernel 4))

(defun ensure-kernel (num-threads)
  "ensures that lparallel:*kernel* exists and matches NUM-THREADS."
  (unless (and lparallel:*kernel*
               (= num-threads (lparallel:kernel-worker-count)))
    (when lparallel:*kernel*
      (lparallel:end-kernel lparallel:*kernel*))
    (setf lparallel:*kernel* (lparallel:make-kernel num-threads))))

(defun parallel-map (num-threads fn inputs)
  "applies FN to each element in INPUTS using NUM-THREADS parallel workers."
  (ensure-kernel num-threads)  ; make sure the kernel is set up with correct threads
  (lparallel:pmap 'vector fn inputs))

;; print list of conses properly
(defun print-cons (x)
  (cond
    ((consp x)
     (format t "(")
     (print-cons (car x))
     (let ((rest (cdr x)))
       (cond
         ((null rest))  ;; do nothing for a proper list
         ((consp rest)  ;; continue printing for another pair
          (format t " ")
          (print-cons rest))
         (t ;; handle improper cons case explicitly
          (format t " . ")
          (print-cons rest))))
     (format t ")"))
    (t (princ x))))

(defun last-atom (seq)
  (car (last seq)))