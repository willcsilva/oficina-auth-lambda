# Diagrama das Entidades

```mermaid
classDiagram

    class ClienteEntity {
        +Long id
        +String nome
        +String email
        +String telefone
    }

    class PecaEntity {
        +Long id
        +String nome
        +String codigoFabricante
        +Integer quantidadeEstoque
        +Integer estoqueMinimo
        +BigDecimal precoVenda
        +String tipo
    }

    class ItemOrdemServicoEntity {
        +Long id
        +BigDecimal precoUnitario
        +Integer quantidade
        +BigDecimal subtotal
    }

    class OrdemServicoEntity {
        +Long id
        +String placaVeiculo
        +String status
        +BigDecimal valorTotal
        +String resumoItens
        +Boolean ativo
    }

    OrdemServicoEntity --> ItemOrdemServicoEntity : contém
    ItemOrdemServicoEntity --> PecaEntity : usa
    OrdemServicoEntity --> ClienteEntity : pertence a