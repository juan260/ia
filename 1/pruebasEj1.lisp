;;;; RENDIMIENTOS:
;;;;[28]> (time (sc-classifier cats texts #'sc-rec))
;;;;Real time: 1.54E-4 sec.
;;;;Run time: 0.0 sec.
;;;;Space: 192 Bytes
;;;;((1 1) (2 0.8017837))

;;;; RENDIMIENTOS
;;;;[29]> (time (sc-classifier cats texts #'sc-mapcar))
;;;;Real time: 1.35E-4 sec.
;;;;Run time: 0.0 sec.
;;;;Space: 768 Bytes
;;;;((1 1) (2 0.8017837))


;;;; RENDIMIENTOS CON LOS DATOS DEL ENUNCIADO

(setf cats '((1 43 23 12) (2 33 54 24)))
(setf texts '((1 3 22 134) (2 43 26 58)))
(time (sc-classifier cats texts #'sc-rec))
(time (sc-classifier cats texts #'sc-mapcar))

;;;;[32]> (time (sc-classifier cats texts #'sc-rec))
;;;;Real time: 1.51E-4 sec.
;;;;Run time: 0.0 sec.
;;;;Space: 160 Bytes
;;;;((2 0.48981872) (1 0.8155509))

;;;;[33]> (time (sc-classifier cats texts #'sc-mapcar))
;;;;Real time: 7.2E-5 sec.
;;;;Run time: 0.0 sec.
;;;;Space: 736 Bytes
;;;;((2 0.48981872) (1 0.8155509))
