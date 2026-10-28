export AFL_NO_UI=1
export AFL_SKIP_CPUFREQ=1
export AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1
export AFL_NO_AFFINITY=1
export AFL_AUTORESUME=1

DURATION="${DURATION:-19800}" #5.5 jam



# Deteksi CPU yang tersedia
if command -v nproc >/dev/null 2>&1; then
    CPU_COUNT="$(nproc)"
else
    CPU_COUNT="$(getconf _NPROCESSORS_ONLN)"
fi

JOBS="$CPU_COUNT"
echo "CPU tersedia : $CPU_COUNT"
echo "AFL workers  : $JOBS"


# Master
afl-fuzz \
	-M master \
	-i fuzz-seeds \
	-o fuzz-out \
    -V $DURATION \
	-m none -- \
	./sapi/cli/php -r 'unserialize(file_get_contents("php://stdin"));' 2>&1 &


# Slaves
for ((i = 1; i < JOBS; i++)); do

	afl-fuzz \
		-S "slave$i" \
		-d \
		-i fuzz-seeds \
		-o fuzz-out \
	    -V $DURATION \
		-m none -- \
		./sapi/cli/php -r 'unserialize(file_get_contents("php://stdin"));' 2>&1 &
done

wait

