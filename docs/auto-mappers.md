# 🔁 Diagrama Automático de Mappers (Entity → DTO)

Este diagrama representa como cada *Mapper* da aplicação converte uma **Entity JPA**  
em um **DTO** correspondente.  
O objetivo é visualizar claramente a camada de transformação do seu domínio.

```mermaid
flowchart LR

    %% ================================
    %% ENTIDADES (JPA)
    %% ================================
    CE[ClienteEntity]
    PE[PecaEntity]
    IOSE[ItemOrdemServicoEntity]
    OSE[OrdemServicoEntity]

    %% ================================
    %% MAPPERS
    %% ================================
    CM[ClienteMapper]
    PM[PecaMapper]
    IM[ItemOrdemServicoMapper]
    OM[OrdemServicoMapper]

    %% ================================
    %% DTOS
    %% ================================
    CDTO[ClienteDTO]
    PDTO[PecaDTO]
    IDTO[ItemOrdemServicoDTO]
    OSDTO[OrdemServicoResponseDTO]

    %% ================================
    %% RELAÇÕES MAPPER → DTO
    %% ================================

    CE --> CM --> CDTO
    PE --> PM --> PDTO
    IOSE --> IM --> IDTO

    OSE --> OM --> OSDTO

    %% ======================================================
    %% MAPPERS COMPOSTOS
    %% (quando um mapper usa outros internamente)
    %% ======================================================
    OM --> CM
    OM --> IM