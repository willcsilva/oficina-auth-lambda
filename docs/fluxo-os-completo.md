```mermaid
sequenceDiagram
    autonumber
    participant C as Cliente / Front-End
    participant O as OrdemServicoController
    participant R as OrdemServicoRepository
    participant P as PecaRepository
    participant M as OrdemServicoMapper

    C ->> O: POST /api/os/abrir/{clienteId}
    O ->> R: save(os)
    R -->> O: OrdemServicoEntity
    O ->> M: toDTO
    O -->> C: OrdemServicoResponseDTO

    C ->> O: PATCH /api/os/{id}/adicionar-item
    O ->> P: findById(itemId)
    O ->> R: save(os)
    O ->> M: toDTO
    O -->> C: DTO atualizado

    C ->> O: PATCH /api/os/{id}/atualizar-orcamento
    loop Por cada item
        O ->> P: buscar peça
        O ->> R: salvar item
    end
    O ->> M: toDTO
    O -->> C: OS atualizada

    C ->> O: PATCH /api/os/{id}/aguardar-aprovacao
    O ->> R: saveAndFlush
    O -->> C: links (aprovar/recusar/pdf)

    C ->> O: GET /api/os/{id}/faturamento-pdf
    O ->> R: findById
    O -->> C: PDF

    C ->> O: PATCH /api/os/{id}/finalizar
    O ->> R: save
    O ->> M: toDTO
    O -->> C: OS finalizada