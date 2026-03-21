# Arquitetura Geral da Aplicação

Este diagrama mostra como os módulos Controller → Mapper → DTO → Repository → Entity se relacionam.

```mermaid
flowchart LR
    subgraph Controllers
        OS[OrdemServicoController]
        PC[PecaController]
        CC[ClienteController]
    end

    subgraph Mappers
        OM[OrdemServicoMapper]
        IM[ItemOrdemServicoMapper]
        PM[PecaMapper]
        CM[ClienteMapper]
    end

    subgraph DTOs
        OSDTO[OrdemServicoResponseDTO]
        ItemDTO[ItemOrdemServicoDTO]
        PecaDTO[PecaDTO]
        ClienteDTO[ClienteDTO]
    end

    subgraph Persistence
        OSRepo[OrdemServicoRepository]
        PecaRepo[PecaRepository]
        ClienteRepo[ClienteRepository]
    end

    subgraph Entities
        OSE[OrdemServicoEntity]
        IOSE[ItemOrdemServicoEntity]
        PE[PecaEntity]
        CE[ClienteEntity]
    end

    OS --> OM
    PC --> PM
    CC --> CM

    OM --> OSDTO
    IM --> ItemDTO
    PM --> PecaDTO
    CM --> ClienteDTO

    OS --> OSRepo
    PC --> PecaRepo
    CC --> ClienteRepo

    OSRepo --> OSE
    PecaRepo --> PE
    ClienteRepo --> CE

    OSE --> IOSE
    IOSE --> PE
    OSE --> CE