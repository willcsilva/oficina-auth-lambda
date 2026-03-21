# 🏛️ Arquitetura Geral da Aplicação

```mermaid
flowchart TD

    %% ===========================
    %% CAMADA DE APRESENTAÇÃO
    %% ===========================
    subgraph Controllers
        OSC[OrdemServicoController]
        CC[ClienteController]
        PC[PecaController]
        AC[AdminController]
        AuthC[AuthController]
    end

    %% ===========================
    %% CAMADA DE SERVIÇOS
    %% ===========================
    subgraph Services
        OSS[OrdemServicoService]
        PDFS[PdfService]
        RLS[RelatorioService]
        JWT[JwtService]
    end

    %% ===========================
    %% CAMADA DE MAPPERS
    %% ===========================
    subgraph Mappers
        OM[OrdemServicoMapper]
        IM[ItemOrdemServicoMapper]
        PM[PecaMapper]
        CM[ClienteMapper]
    end

    %% ===========================
    %% CAMADA DE DTOs
    %% ===========================
    subgraph DTOs
        OSDTO[OrdemServicoResponseDTO]
        IDTO[ItemOrdemServicoDTO]
        PDTO[PecaDTO]
        CDTO[ClienteDTO]
    end

    %% ===========================
    %% CAMADA DE REPOSITÓRIOS
    %% ===========================
    subgraph Repositories
        OSR[OrdemServicoRepository]
        IOR[ItemOrdemServicoRepository]
        PR[PecaRepository]
        CR[ClienteRepository]
        VR[VeiculoRepository]
    end

    %% ===========================
    %% CAMADA DE ENTIDADES
    %% ===========================
    subgraph Entities
        OSE[OrdemServicoEntity]
        IOSE[ItemOrdemServicoEntity]
        PE[PecaEntity]
        CE[ClienteEntity]
        VE[VeiculoEntity]
    end


    %% CONTROLLER -> SERVICE
    OSC --> OSS
    OSC --> PDFS
    CC --> OSS
    PC --> OSS
    AC --> RLS
    AuthC --> JWT

    %% SERVICE -> REPOSITORY
    OSS --> OSR
    OSS --> IOR
    OSS --> PR
    OSS --> CR
    OSS --> VR

    PDFS --> OSR
    PDFS --> PR

    RLS --> OSR
    RLS --> IOR
    RLS --> CR

    %% REPOSITORY -> ENTITY
    OSR --> OSE
    IOR --> IOSE
    PR --> PE
    CR --> CE
    VR --> VE

    %% MAPPER -> DTO
    OM --> OSDTO
    IM --> IDTO
    PM --> PDTO
    CM --> CDTO

    %% ENTITY -> MAPPER
    OSE --> OM
    IOSE --> IM
    PE --> PM
    CE --> CM