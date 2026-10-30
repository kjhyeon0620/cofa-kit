#!/usr/bin/env bash
# 커밋 전 점검. AGENTS.md·docs/process.md 규칙 중 코드로 확인할 수 있는 것만 검사한다.
# 사용: bash scripts/check.sh
spec=docs/spec.md
fail=0
err() { echo "FAIL: $1"; fail=1; }
warn() { echo "WARN: $1"; }
# '## <제목>'으로 시작하는 섹션 본문만 출력
section() { awk -v h="## $1" 'index($0, h) == 1 {f=1; next} /^## /{f=0} f' "$spec"; }
# 표의 데이터 행 (헤더·구분선 제외)
rows() { section "$1" | grep '^|' | tail -n +3; }

if [ ! -f "$spec" ]; then
  err "$spec 없음"
else
  status=$(awk '/^status:/ {print $2; exit}' "$spec")
  case "$status" in
    ready|in-progress|done) ;;
    *) err "스펙 status가 '$status' (Open 질문을 정리하고 ready로 바꾼 뒤 구현)" ;;
  esac
  [ "$status" = draft ] || ! section "미결 질문" | grep -q '^- \[ \]' \
    || err "status가 $status인데 남은 Open 질문이 있음"
  section "결정 기록" | grep -Eq '^- [0-9]' || err "Decisions에 기록된 결정이 없음"
  grep -q '^- 제외: *(' "$spec" && warn "제외 범위가 비어 있음"

  if [ "$status" = done ]; then
    rows "완료 증거" | awk -F'|' '$4 ~ /^ *$/ {bad=1} END {exit !bad}' \
      && err "완료 증거에 결과 칸이 빈 행이 있음"
    rows "알려진 격차" | awk -F'|' '$2 !~ /^ *$/ {ok=1} END {exit !ok}' \
      || err "알려진 격차가 비어 있음 (약점을 설명할 재료)"
    grep -Eq '^- 어긋난 점: *$' "$spec" && warn "회고가 비어 있음"
  fi
fi

if ls tests/test_*.py >/dev/null 2>&1 || ls test_*.py >/dev/null 2>&1; then
  if python3 -m pytest --version >/dev/null 2>&1; then
    python3 -m pytest -q || err "테스트 실패"
  else
    # pytest가 없으면 test_*.py의 test_* 함수를 직접 실행
    python3 - <<'PY' || err "테스트 실패"
import glob, importlib.util, sys, traceback
files = glob.glob("tests/test_*.py") + glob.glob("test_*.py")
sys.path[:0] = [".", "tests"]
ran = failed = 0
for f in files:
    spec = importlib.util.spec_from_file_location(f[:-3].replace("/", "."), f)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    for name in dir(mod):
        if name.startswith("test_") and callable(getattr(mod, name)):
            ran += 1
            try:
                getattr(mod, name)()
            except Exception:
                failed += 1
                print(f"{f}::{name} FAILED"); traceback.print_exc()
print(f"{ran - failed}/{ran} passed")
sys.exit(1 if failed or not ran else 0)
PY
  fi
else
  warn "테스트 파일 없음 (tests/test_*.py)"
fi

[ $fail -eq 0 ] && echo "OK" || exit 1
