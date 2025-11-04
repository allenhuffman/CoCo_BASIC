all: lights

lights: lights.bas
	decbpp < lights.bas > redistribute/lights.bas

ifneq ("$(wildcard /media/share1/COCO/drive0.dsk)", "")
	decb copy -tr redistribute/lights.bas /media/share1/COCO/drive0.dsk,LIGHTS.BAS
endif
	cat redistribute/lights.bas

release:
	(cd /home/rca/projects; zip -r /tmp/lights.zip lights)
	rcp /tmp/lights.zip ricka@rickadams.org:/home/ricka/rickadams.org/downloads/lights.zip
	rm -f /tmp/lights.zip
