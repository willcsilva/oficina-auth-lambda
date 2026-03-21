# 🧭 Diagrama Automático dos Controllers

Este diagrama mostra a relação entre os **Controllers**,  
suas dependências principais e seu papel dentro da aplicação.

```mermaid
flowchart LR

    %% ============================================
    %% CONTROLLERS
    %% ============================================
    OSC[OrdemServicoController]
    CC[ClienteController]
    PC[PecaController]
    AC[AdminController]
    AuthC[AuthController]

    %% ============================================
    %% SERVICES
    %% ============================================
    OSS[OrdemServicoService]
    PDFS[PdfService]
    RLS[RelatorioService]
    JWT[JwtService]

    %% ============================================
    %% REPOSITORIES
    %% ============================================
    OSR[OrdemServicoRepository]
    CR[ClienteRepository]
    PR[PecaRepository]
    IOR[ItemOrdemServicoRepository]
    IR[ItemPecaRepository]
    VR[VeiculoRepository]

    %% ============================================
    %% MAPPERS
    %% ============================================
    OM[OrdemServicoMapper]
    PM[PecaMapper]
    CM[ClienteMapper]

    %% ============================================
    %% RELAÇÕES CONTROLLER → SERVICE / REPO
    %% ============================================

    %% OrdemServicoController
    OSC --> OSR
    OSC --> PR
    OSC --> CR
    OSC --> PDFS
    OSC --> OSS
    OSC --> OM

    %% ClienteController
    CC --> CR
    CC --> CM

    %% PecaController
    PC --> PR
    PC --> PM

    %% Admin Controller
    AC --> RLS

    %% Auth Controller
    AuthC --> JWT
    AuthC --> CR

    %% ============================================
    %% ORGANIZAÇÃO VISUAL
    %% ============================================
    subgraph Controllers
        OSC
        CC
        PC
        AC
        AuthC
    end

    subgraph Services
        OSS
        PDFS
        RLS
        JWT
    end

    subgraph Repositories
        OSR
        CR
        PR
        IOR
        IR
        VR
    end

    subgraph Mappers
        OM
        PM
        CM
    end