with import <nixpkgs> { };
mkShell rec {
  name = "bors";

  # Note that with lorri we define these variables here due to
  # https://github.com/target/lorri/issues/153, but when using just
  # nix-shell we should define them in the shellHook
  MIX_ARCHIVES = toString ./.mix;
  PGDIR = toString ./.postgres;
  PGHOST = "${PGDIR}";
  PGDATA = "${PGDIR}/data";
  PGLOG = "${PGDIR}/log";

  DATABASE_URL = "postgresql:///postgres?host=${PGDIR}";
  buildInputs = [ elixir postgresql_12 nodejs-14_x inotify-tools ];
  src = null;
  shellHook = ''
    set -ex
    # Careful: when using PGDIR, even when not `export`ing it, it
    # overrides the value defined outside of the shellHook, and end
    # up being /build/.postgres in the postgres_xxx scripts...
    pgdir="$(pwd)/.postgres"
    if test ! -d "$pgdir"; then
         mkdir "$pgdir"
    fi
    set +ex

    # export MIX_ARCHIVES="$(pwd)/.mix";
    # export PGDIR="$(pwd)/.postgres";
    # export PGHOST="$PGDIR";
    # export PGDATA="$PGDIR/data";
    # export PGLOG="$PGDIR/log";
    # export DATABASE_URL="postgresql:///postgres?host=$PGDIR";
  '';
}
