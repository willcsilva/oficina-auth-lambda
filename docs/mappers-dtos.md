# Relação entre Mappers, Entities e DTOs

```mermaid
flowchart LR

    classDef box fill:#fff,stroke:#333;

    subgraph Entities
        CE::box
        PE::box
        IOSE::box
        OSE::box
    end

    subgraph Mappers
        CM["ClienteMapper"]:::box
        PM["PecaMapper"]:::box
        IM["ItemOrdemServicoMapper"]:::box
        OM["OrdemServicoMapper"]:::box
    end

    subgraph DTOs
        CDTO::box
        PDTO::box
        IDTO::box
        OSDTO::box
    end

    CE --> CM --> CDTO
    PE --> PM --> PDTO
    IOSE --> IM --> IDTO
    OSE --> OM --> OSDTO