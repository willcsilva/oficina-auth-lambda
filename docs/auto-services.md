# ⚙️ Diagrama Automático de Services

Este diagrama mostra a interação entre os **Services**, **Repositories**,  
**Entities** e **Controllers** dentro da aplicação Oficina.

Os Services são responsáveis por regras de negócio, geração de PDFs, relatórios e integrações externas.

---

```mermaid
flowchart LR

    %% ======================================================
    %% CONTROLLERS
    %% ======================================================
    OSC[OrdemServicoController]
    CC[ClienteController]
    PC[PecaController]

    %% ======================================================
    %% SERVICES
    %% ======================================================
    OSS[OrdemServicoService]
    PDFS[PdfService]
    RLS[RelatorioService]

    %% ======================================================
    %% REPOSITORIES
    %% ======================================================
    OSR[OrdemServicoRepository]
    IR[ItemOrdemServicoRepository]
    CR[ClienteRepository]
    PR[PecaRepository]
    VR[VeiculoRepository]

    %% ======================================================
    %% ENTITIES
    %% ======================================================
    OSE[OrdemServicoEntity]
    IOSE[ItemOrdemServicoEntity]
    CE[ClienteEntity]
    PE[PecaEntity]
    VE[VeiculoEntity]

    %% ======================================================
    %% RELAÇÕES CONTROLLER → SERVICE
    %% ======================================================
    OSC --> OSS
    OSC --> PDFS
    CC --> OSS
    PC --> OSS

    %% ======================================================
    %% SERVICE → REPOSITORIES
    %% ======================================================
    OSS --> OSR
    OSS --> IR
    OSS --> PR
    OSS --> CR
    OSS --> VR

    PDFS --> OSR
    PDFS --> PR

    RLS --> OSR
    RLS --> IR
    RLS --> CR

    %% ======================================================
    %% REPOSITORIES → ENTITIES
    %% ======================================================
    OSR --> OSE
    IR --> IOSE
    CR --> CE
    PR --> PE
    VR --> VE