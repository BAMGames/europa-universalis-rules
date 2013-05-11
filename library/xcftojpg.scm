(define (xcftojpg arg)
  (let* (
         (input (string-append "figures/" arg))
         (fn (string-append input ".jpg"))
         (fx (string-append input ".xcf"))
         (Ifx (car (gimp-file-load 1 fx fx)))
         (Ifl (car (gimp-image-flatten Ifx)))
         )
    (file-jpeg-save 1 Ifx Ifl fn fn 0.9 1 0 0 "" 0 0 0 0)
    )
  )