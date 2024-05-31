# --preserve=REGEX       preserve environment variables matching REGEX
#     --pure             supprime les variables d'environnement existantes
# -C, --container        lance la commande dans un conteneur isolé
# -N, --network          permet aux conteneurs d'accéder au réseau
# -F, --emulate-fhs      pour containers, émule le standard de la hiérarchie
#                        des systèmes de fichiers (FHS)

# Make ./persistent-profile a symlink to the `guix shell ...` result, and
# register it as a garbage collector root, i.e. prevent garbage collection
# during(!) the `guix shell ...` session:
#  --root=./persistent-profile \

# Create environment for the package that the '...' EXPR evaluates to.
# --expression='(list (@ (gnu packages bash) bash) "include")' \
#

export JAVA_HOME=$(guix build openjdk | grep "\-jdk$")
# printf "JAVA_HOME: %s\n" "$JAVA_HOME"

# sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
# sudo apt-get install libc6 libncurses5 libstdc++6 lib32z1 libbz2-1.0:i386

GXHOME="$HOME/android/guix-shell-home"

# .config/Google/AndroidStudio2023.3/options/ide.general.local.xml
#3:    <option name="browserPath" value="/bin/firefox" />

# /home/bost/android/guix-shell-home/Android/Sdk/platform-tools/adb
# in the guix-shell:
# [env]$ /home/bost/Android/Sdk/platform-tools/adb --version # Android Debug Bridge version 1.0.41
# $ guix install adb # Android Debug Bridge version 1.0.36

# in Android Studio:
# Settings -> Build, Execution, Deployment -> Debugger:
# set "ADB server USB backend" to "libusb"

# create a /usr/bin pointing to the /bin
# --symlink=/usr/bin=/bin \
# --symlink=/usr/bin=bin \

# IDE Settings: File -> Manage IDE Settings -> Import Settings...
# /home/bost/.config/Google/AndroidStudio2023.3/settings.zip

# Initially the $HOME/.config/Google is needed to be shared (via --share) for
# the export of IDE Settings. Then the settings.zip can be copied to
# $GXHOME/.config/Google and only the
# --share=$GXHOME/.config/Google=$HOME/.config/Google is enough.

# [ ! -d   $HOME/.config/Google ] && mkdir -p   $HOME/.config/Google
# [ ! -d $GXHOME/.config/Google ] && mkdir -p $GXHOME/.config/Google

[ ! -d   $HOME/.local/share/Google ] && mkdir -p   $HOME/.local/share/Google
[ ! -d $GXHOME/.local/share/Google ] && mkdir -p $GXHOME/.local/share/Google

# TODO make the $HOME/bin and $HOME/scm-bin available in the container:
# --expose=$HOME/bin
# --expose=$HOME/scm-bin


# --share=$HOME/.config/Google \
# --share=$GXHOME/.config/Google=$HOME/.config/Google \
# TODO try --expose=$HOME/.ssh instead of --share=$HOME/.ssh

set -x
# --share=SPEC       pour les conteneurs, partage le système de fichier hôte en lecture-écriture en fonction de SPEC
# --expose=SPEC      pour les conteneurs, expose en lecture-seule le système de fichiers hôte en fonction de SPEC
# -S, --symlink=SPEC pour les conteneurs, ajoute des liens symboliques vers le profil selon la SPEC, p. ex. « /usr/bin/env=bin/env ».

guix shell \
     --emulate-fhs \
     --pure \
     --container \
     --network \
     '--preserve=^JAVA_HOME$' \
     '--preserve=^DISPLAY$' \
     '--preserve=^XAUTHORITY$' --expose=$XAUTHORITY \
     --expose=/sys \
     --share=$HOME/.ssh \
     --share=$HOME/.bash_history \
     --share=$GXHOME/.config/Google=$HOME/.config/Google \
     --share=$GXHOME/.local/share/Google=$HOME/.local/share/Google \
     --share=$GXHOME/.bash_profile=$HOME/.bash_profile \
     --share=$GXHOME/.bashrc=$HOME/.bashrc \
     --share=$GXHOME/.android=$HOME/.android \
     --share=$GXHOME/.cache=$HOME/.cache \
     --share=$GXHOME/.gradle=$HOME/.gradle \
     --share=$GXHOME/.java=$HOME/.java \
     --share=$GXHOME/bin=$HOME/bin \
     --share=$GXHOME/Android=$HOME/Android \
     --share=$GXHOME/AndroidStudioProjects=$HOME/AndroidStudioProjects \
     --share=$GXHOME/android-studio=$HOME/android-studio \
     bash direnv gnupg help2man git strace glibc-locales \
     vim ripgrep fd findutils procps which sed grep htop sudo \
     coreutils \
     zlib \
     bzip2 \
     freetype \
     libxext \
     java-commons-cli \
     openjdk \
     libx11 libxrender libxtst libxi fontconfig libxrandr \
     e2fsprogs \
     android-file-transfer android-make-stub android-udev-rules \
     libgccjit \
     usbutils \
     adb libusb \
     firefox \
     xdotool \
     -- bash
