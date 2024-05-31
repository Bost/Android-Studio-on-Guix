#!/usr/bin/env -S guile \\
-L /home/bost/dev/dotfiles/guix/common -L /home/bost/dev/dotfiles/guix/home/common -e (run) -s
!#

(define-module (run)
  #:use-module (utils)
  #:use-module (tests)
  #:use-module (srfi srfi-1) ;; remove
  #:use-module (fs-utils) ;; user-home
  #:use-module (guix build utils) ;; mkdir-p
  #:export (main)
  )

(define m (module-name-for-logging))
(evaluating-module)

(define HOME (user-home))
;; (format #t "HOME ~a\n" HOME)

;; # --preserve=REGEX       preserve environment variables matching REGEX
;; #     --pure             supprime les variables d'environnement existantes
;; # -C, --container        lance la commande dans un conteneur isolé
;; # -N, --network          permet aux conteneurs d'accéder au réseau
;; # -F, --emulate-fhs      pour containers, émule le standard de la hiérarchie
;; #                        des systèmes de fichiers (FHS)

;; # Make ./persistent-profile a symlink to the `guix shell ...` result, and
;; # register it as a garbage collector root, i.e. prevent garbage collection
;; # during(!) the `guix shell ...` session:
;; #  --root=./persistent-profile \

;; # Create environment for the package that the '...' EXPR evaluates to.
;; # --expression='(list (@ (gnu packages bash) bash) "include")' \
;; #

(define (process output)
  #;(format #t "(test-type output): ~a\n" (test-type output))
  ;; (format #t "output: ~a\n" output)
  ((comp
    car
    (partial remove (lambda (string) (has-suffix? string "-jdk"))))
   output))

(define JAVA_HOME
  (let* [(command "guix build openjdk")
         (ret (exec command))]
    (if (= 0 (car ret))
        (let* ((output (cdr ret)))
          (process output))
        (begin
          ;; (error-command-failed "[module]" "extra_info")
          *unspecified*))))
;; (format #t "JAVA_HOME ~a\n" JAVA_HOME)

;; # sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
;; # sudo apt-get install libc6 libncurses5 libstdc++6 lib32z1 libbz2-1.0:i386

(define GXHOME (str HOME "/android/guix-shell-home"))
;; (format #t "GXHOME ~a\n" GXHOME)

;; # .config/Google/AndroidStudio2023.3/options/ide.general.local.xml
;; #3:    <option name="browserPath" value="/bin/firefox" />

;; # /home/bost/android/guix-shell-home/Android/Sdk/platform-tools/adb
;; # in the guix-shell:
;; # [env]$ /home/bost/Android/Sdk/platform-tools/adb --version # Android Debug Bridge version 1.0.41
;; # $ guix install adb # Android Debug Bridge version 1.0.36

;; # in Android Studio:
;; # Settings -> Build, Execution, Deployment -> Debugger:
;; # set "ADB server USB backend" to "libusb"

;; # create a /usr/bin pointing to the /bin
;; # --symlink=/usr/bin=/bin \
;; # --symlink=/usr/bin=bin \

;; # IDE Settings: File -> Manage IDE Settings -> Import Settings...
;; # /home/bost/.config/Google/AndroidStudio2023.3/settings.zip

;; # Initially the $HOME/.config/Google is needed to be shared (via --share) for
;; # the export of IDE Settings. Then the settings.zip can be copied to
;; # $GXHOME/.config/Google and only the
;; # --share=$GXHOME/.config/Google=$HOME/.config/Google is enough.

(map mkdir-p
     (list
      (str HOME   "/.config/Google")
      (str GXHOME "/.config/Google")
      (str HOME   "/.local/share/Google")
      (str GXHOME "/.local/share/Google")))

;; # TODO make the $HOME/bin and $HOME/scm-bin available in the container:
;; # --expose=$HOME/bin
;; # --expose=$HOME/scm-bin

;; # --share=$HOME/.config/Google \
;; # --share=$GXHOME/.config/Google=$HOME/.config/Google \
;; # TODO try --expose=$HOME/.ssh instead of --share=$HOME/.ssh

;; # --share=SPEC       pour les conteneurs, partage le système de fichier hôte en lecture-écriture en fonction de SPEC
;; # --expose=SPEC      pour les conteneurs, expose en lecture-seule le système de fichiers hôte en fonction de SPEC
;; # -S, --symlink=SPEC pour les conteneurs, ajoute des liens symboliques vers le profil selon la SPEC, p. ex. « /usr/bin/env=bin/env ».

(define* (main #:rest args)
  "Usage:
(main \"<ignored>\" \"-f\" \"arg0\")"
  #;((comp dbg) args)
  (exec
   (list
    "guix shell"
    "--emulate-fhs"
    "--pure"
    "--container"
    "--network"
    "'--preserve=^JAVA_HOME$'"
    "'--preserve=^DISPLAY$'"
    "'--preserve=^XAUTHORITY$' --expose=$XAUTHORITY"
    "--expose=/sys"
    (format #f "--share=~a/.ssh" HOME)
    (format #f "--share=~a/.bash_history" HOME)
    (format #f "--share=~a/.config/Google=~a/.config/Google" GXHOME HOME)
    (format #f "--share=~a/.local/share/Google=~a/.local/share/Google" GXHOME HOME)
    (format #f "--share=~a/.bash_profile=~a/.bash_profile" GXHOME HOME)
    (format #f "--share=~a/.bashrc=~a/.bashrc" GXHOME HOME)
    (format #f "--share=~a/.android=~a/.android" GXHOME HOME)
    (format #f "--share=~a/.cache=~a/.cache" GXHOME HOME)
    (format #f "--share=~a/.gradle=~a/.gradle" GXHOME HOME)
    (format #f "--share=~a/.java=~a/.java" GXHOME HOME)
    (format #f "--share=~a/bin=~a/bin" GXHOME HOME)
    (format #f "--share=~a/Android=~a/Android" GXHOME HOME)
    (format #f "--share=~a/AndroidStudioProjects=~a/AndroidStudioProjects" GXHOME HOME)
    (format #f "--share=~a/android-studio=~a/android-studio" GXHOME HOME)
    "bash direnv gnupg help2man git strace glibc-locales"
    "vim ripgrep fd findutils procps which sed grep htop sudo"
    "coreutils"
    "zlib"
    "bzip2"
    "freetype"
    "libxext"
    "java-commons-cli"
    "openjdk"
    "libx11 libxrender libxtst libxi fontconfig libxrandr"
    "e2fsprogs"
    "android-file-transfer android-make-stub android-udev-rules"
    "libgccjit"
    "usbutils"
    "adb libusb"
    "firefox"
    "xdotool"
    ;; "-- bash"
    )))
(testsymb 'main)

(module-evaluated)
