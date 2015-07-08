{ nixpkgs ? import ./nixpkgs-dbf1e0f {},
  tompkgs ? import ./tompkgs {} }:

with nixpkgs;

pkgs.buildPythonPackage {
  name = "break-numba";
  srcs = ./.;
  propagatedBuildInputs = [
    tompkgs.numba
    pythonPackages.ipython
  ];
}
