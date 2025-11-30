#!/bin/bash

# ==============================================================================
# 프로젝트 메인 스크립트: 자동화된 코드 빌드 및 테스트 환경
# 실행 예시: ./auto_builder.sh my_program.c input_data.txt
# ==============================================================================

# --- 1. 변수 및 환경 설정 ---
SOURCE_FILE=$1 # 테스트할 C/Python 소스코드 파일
INPUT_FILE=$2  # 테스트 입력 데이터 파일
OUTPUT_LOG="test_run_$(date +%Y%m%d_%H%M%S).log"
ERROR_FLAG=0 # 오류 발생 플래그 (0: 정상, 1: 오류)

echo "테스트 시작: $(date)"
echo "대상 소스코드: $SOURCE_FILE, 입력 파일: $INPUT_FILE"

# ------------------------------------------------------------------------------
# [기능 1] 소스코드 자동 처리 모듈
# ------------------------------------------------------------------------------
echo -e "\n--- 1. 소스코드 컴파일/처리 ---"
if [[ "$SOURCE_FILE" == *".c" ]]; then
    echo "C 파일을 컴파일 합니다..."
    gcc "$SOURCE_FILE" -o "./test_program" 2>> "$OUTPUT_LOG"

    if [ $? -ne 0 ]; then
        echo "ERROR: 컴파일 실패!"
        ERROR_FLAG=1
    fi

elif [[ "SOURCE_FILE" == *".py" ]]; then
    echo "Python 파일의 실행 권한을 설정합니다."
    chmod +x "SOURCE_FILE"
    
else
    echo "ERROR: 지원하지 않는 파일 형식입니다."
    ERROR_FLAG=1
fi 

# 컴파일 실패 시 스크립트 종료
if [ $ERROR_FLAG -ne 0 ]; then
    echo "테스트가 중단되었습니다."
    exit 1
fi

# ------------------------------------------------------------------------------
# [기능 3] 환경 변수 기반 실행 제어
# ------------------------------------------------------------------------------
echo -e "\n--- 2. 환경 변수 설정 (DEBUG_MODE) ---" | tee -a "$OUTPUT_LOG"
export DEBUG_MODE="true" # 환경 변수 설정
echo "DEBUG_MODE='true'로 설정됨" | tee -a "$OUTPUT_LOG"

# ------------------------------------------------------------------------------
# [기능 2] 테스트 입력 자동 전달 및 실행
# ------------------------------------------------------------------------------
echo -e "\n--- 3. 테스트 실행 및 입력 전달 ---" | tee -a "$OUTPUT_LOG"
PROGRAM_CMD=""

if [[ "$SOURCE_FILE" == *".c" ]]; then
    PROGRAM_CMD="./test_program"
elif [[ "$SOURCE_FILE" == *".py" ]]; then
    PROGRAM_CMD="python3 $SOURCE_FILE"
fi

# 입력 리다이렉션을 통해 C/Python 프로그램에 데이터 전달 (핵심 연동)
# 실행 결과를 임시 출력 파일에 저장
echo "실행 중..."
$PROGRAM_CMD < "$INPUT_FILE" > "test_output.temp" 2>&1
EXECUTION_STATUS=$? # 프로그램 종료 상태 저장

# ------------------------------------------------------------------------------
# [기능 4] 실행 로그 기록 및 분석
# ------------------------------------------------------------------------------
echo -e "\n--- 4. 실행 로그 기록 및 시스템 분석 ---" | tee -a "$OUTPUT_LOG"

# 프로그램 출력 내용 기록
echo "=== 프로그램 출력 결과 ===" >> "$OUTPUT_LOG"
cat "test_output.temp" >> "$OUTPUT_LOG"

# 시스템 및 리소스 사용 현황 기록
echo "=== 시스템 프로세스 현황 (ps -ef) ===" >> "$OUTPUT_LOG"
ps -ef | head -n 5 >> "$OUTPUT_LOG" # 상위 5줄만 기록 (간소화)

# 오류 키워드 분석
ERROR_COUNT=$(grep -i "error" "test_output.temp" | wc -l)
if [ "$EXECUTION_STATUS" -ne 0 ] || [ "$ERROR_COUNT" -gt 0 ]; then
    echo "WARNING: 프로그램이 비정상 종료되거나 출력에 오류 키워드가 포함되어 있습니다." | tee -a "$OUTPUT_LOG"
    ERROR_FLAG=1
fi

# 환경 변수 해제 및 정리
unset DEBUG_MODE
rm "test_output.temp"
[ -f "./test_program" ] && rm "./test_program"

echo -e "\n테스트 완료. 최종 상태: $( [ $ERROR_FLAG -eq 0 ] && echo 'SUCCESS' || echo 'FAILED' )" | tee -a "$OUTPUT_LOG"