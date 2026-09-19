# cnc-ddraw (l1_miku Game Client Compatibility Wrapper)

본 저장소는 2000년대 초반 **l1_miku game server** 클라이언트를 **Windows 11 / 10** 환경에서 가상 머신(VM) 없이 네이티브 성능으로 구동하기 위한 DirectDraw API 래퍼(Wrapper) 서브모듈입니다.

---

## 1. 개요 및 주요 기능

2000년대 초반 클라이언트는 DirectDraw (DirectX 7 이하) 기반 16비트 컬러(High Color) 및 저해상도(640x480, 800x600)를 사용하므로, Windows 11 DWM(Desktop Window Manager) 환경에서 다음과 같은 문제가 발생합니다:
- 16비트 풀스크린 전환 실패 및 심각한 렌더링 지연(FPS 드랍)
- 최신 고클럭 CPU에서의 100% 과점유 및 발열
- 풀스크린 강제 및 마우스 가둠(ClipCursor)으로 인한 창 모드 플레이 불가

`cnc-ddraw`는 이러한 문제를 다음과 같이 해결합니다:
1. **DirectDraw → Direct3D 9 / OpenGL / GDI 실시간 변환**: 16비트 버퍼를 32비트로 자동 변환하여 Windows 11에서 부드러운 렌더링 제공.
2. **창 모드(Windowed) 및 마우스 자유 이동**: 풀스크린 전용 클라이언트를 부드러운 창 모드로 전환하며, 마우스가 창 밖으로 자유롭게 이동 가능.
3. **프레임 제한(FPS Limiter)**: `maxfps = 60` 설정을 통해 CPU 과점유를 완벽 차단.
4. **창 크기 조절 및 업스케일링**: 창 모서리를 마우스로 드래그하여 크기 조절 가능, 정수 배율(Integer Scaling) 지원.

---

## 2. 빌드 가이드 (Build Guide)

### 방법 1: Visual Studio MSBuild CLI (권장)

Visual Studio 2022 / 2026 C++ 데스크톱 개발 워크로드가 설치된 환경에서 다음 명령어로 32비트(x86) 릴리즈 DLL을 빌드합니다.

```cmd
:: Visual Studio Developer Command Prompt 또는 MSBuild 직접 호출
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" cnc-ddraw.sln -p:Configuration=Release -p:Platform=x86
```

- **솔루션 구성**: `Release`
- **대상 플랫폼**: `x86` (32비트 클라이언트 바이너리 대응)
- **산출물 경로**: `bin\Release\ddraw.dll` (약 430KB) 및 `bin\Release\ddraw.pdb`

### 방법 2: MinGW-w64 (GCC)

MinGW-w64 (`i686-w64-mingw32-gcc`) 툴체인이 있는 환경에서는 Makefile을 통해 직접 빌드할 수 있습니다.

```cmd
make clean
make _WIN32_WINNT=0x0400
```

또는 `build.cmd` 배치 스크립트를 실행합니다.

---

## 3. 클라이언트 적용 및 배포 방법

1. 빌드 완료된 **`bin\Release\ddraw.dll`** 파일을 l1_miku 클라이언트 실행 파일(`Lin.bin` 또는 실행 파일)이 위치한 폴더에 복사합니다.
2. 동일한 폴더에 **`ddraw.ini`** 설정 파일을 생성(또는 기본 템플릿 복사)합니다.

### 권장 `ddraw.ini` 설정

```ini
; =========================================================
; l1_miku Client Recommended Configuration for Windows 11
; =========================================================

; 창 모드 활성화 (전체화면은 false)
fullscreen=false
windowed=true

; 마우스 드래그로 창 크기 조절 허용
resizable=true

; 4:3 화면 종횡비 유지 (화면 찌그러짐 방지)
maintas=true

; 최신 CPU 100% 점유 방지를 위한 60 프레임 제한
maxfps=60

; 렌더러 백엔드 (Windows 11 권장: d3d9 또는 auto)
renderer=d3d9

; 창 모드 시 마우스 커서 클리핑 해제 (자유로운 마우스 이동)
adjmouse=true

; 비활성화(백그라운드) 상태에서도 화면 갱신 및 백그라운드 구동 유지
nonexclusive=true

; 디버그 및 핫키
; [Alt] + [Enter] : 창 모드 / 전체화면 전환
; [Ctrl] + [Tab]   : 마우스 잠금 해제
```

---

## 4. 라이선스 및 원본 출처

- **Original Upstream**: [FunkyFr3sh/cnc-ddraw](https://github.com/FunkyFr3sh/cnc-ddraw)
- **Repository**: [cosmokobo/cnc-ddraw](https://github.com/cosmokobo/cnc-ddraw)
- **License**: GNU General Public License v3.0 (GPLv3)
