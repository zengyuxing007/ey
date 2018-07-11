API_PROTO_DIR=./api/envoy/api/v2
PROTO_DST_DIR=./api/proto

dirs = ${API_PROTO_DIR}

#api_files: $(foreach dir,$(dirs),$(wildcard $(dir)/*))
api_files= ${API_PROTO_DIR}/core/base.proto

proto_cpp_file: ${api_files}
	@for filename in $^; do\
			format="$${filename##*.}"x; \
			if [ -d $$filename ]; then \
				echo "deal dir[ $$filename ]"; \
				protoc -I=./api/envoy/api/v2/ -I= --cpp_out=${PROTO_DST_DIR} $$filename/*.proto; \
			elif [ $$format="protox" ]; then \
				echo "format [$$format] ---deal file[ $$filename ]"; \
				protoc -I=./api --cpp_out=${PROTO_DST_DIR} $$filename; \
			else \
				echo "$$filename is not proto file";\
			fi \
	done


all:
	./premake4 --file=premake4.lua.dist gmake
	-cd build && make ${CLEAN} all
	cd ..
clean:
	./premake4 --file=premake4.lua.dist gmake
	-cd build && make clean
	cd ..

release: all

