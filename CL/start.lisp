(ql:quickload :cl-collider)

(in-package :sc-user)
(named-readtables:in-readtable :sc)

(setf *sc-synth-program* "/Applications/SuperCollider.app/Contents/Resources/scsynth")
(setf *sc-plugin-paths* (list "/Applications/SuperCollider.app/Contents/Resources/plugins" "/Users/yanndepps/Library/Application\ Support/SuperCollider/Extensions"))
(setf *sc-synthdefs-path* "/Users/yanndepps/Library/Application\ Support/SuperCollider/synthdefs")

(setf *s* (make-external-server "localhost" :port 48800))
(server-boot *s*)

;; create SynthDef
(defsynth sine-wave ((note 60))
  (let* ((freq (midicps note))
         (sig (sin-osc.ar [freq (+ freq 2)] 0 .2)))
    (out.ar 0 sig)))

(setf *synth* (synth 'sine-wave))
(ctrl *synth* :note 38)
(free *synth*)

;; create musical sequence
(defsynth saw-synth ((note 60) (dur 4.0))
  (let* ((env (env-gen.kr (env [0 .2 0] [(* dur .2) (* dur .8)]) :act :free))
         (freq (midicps note))
    	 (sig (lpf.ar (saw.ar freq env) (* freq 2))))
	(out.ar 0 [sig sig])))

(defun make-melody (time n &optional (offset 0))
  (when (> n 0)
    (at time (synth 'saw-synth :note (+ offset (alexandria:random-elt '(62 65 69 72)))))
    (let ((next-time (+ time (alexandria:random-elt '(0 1 2 1.5)))))
      (callback next-time #'make-melody next-time (- n 1) offset))))

(make-melody (quant 4) 16)
(make-melody (+ 4 (quant 4)) 16 12)

(stop)

;; quit SuperCollider server
(server-quit *s*)
