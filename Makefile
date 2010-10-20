LIBS		= oUnit
OCAMLC		= ocamlfind ocamlc -package $(LIBS)
OCAMLOPT	= ocamlfind ocamlopt -package $(LIBS)
BUILD		= ocamlbuild -ocamlc "$(OCAMLC)" -ocamlopt "$(OCAMLOPT)"

test:
	$(BUILD) test.native
	./test.native
