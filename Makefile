bin/hexv: out/hexv.o out/output.o out/print.o
	ld -o bin/hexv out/hexv.o out/output.o out/print.o

out/hexv.o: src/hexv.s
	as -o out/hexv.o src/hexv.s

out/output.o: src/output.s
	as -o out/output.o src/output.s

out/print.o: src/print.s
	as -o out/print.o src/print.s

.PHONY: clean

clean:
	rm -r out bin

$(shell mkdir -p out bin)
