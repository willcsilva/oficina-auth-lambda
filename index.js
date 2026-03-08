const { Client } = require('pg');
const jwt = require('jsonwebtoken');

exports.handler = async (event) => {
    // 1. Extração do identificador (Estou mantendo CPF, mas lembre-se de criá-lo no Banco/Java!)
    const body = typeof event.body === 'string' ? JSON.parse(event.body) : event.body;
    const cpf = body?.cpf?.replace(/\D/g, '');

    if (!cpf || cpf.length !== 11) {
        return { statusCode: 400, body: JSON.stringify({ erro: "CPF inválido. Deve conter 11 dígitos." }) };
    }

    // 2. Configuração do Banco (Envs para a AWS real)
    const client = new Client({
        host: process.env.DB_HOST,         // Na AWS, será o endpoint do seu RDS
        user: process.env.DB_USER,         // Ex: postgres
        password: process.env.DB_PASSWORD, // Senha do RDS
        database: process.env.DB_NAME,     // Ex: oficinadb
        port: 5432
    });

    try {
        await client.connect();
        
        // 3. Busca o cliente na tabela CORRETA (clientes no plural)
        // AVISO: Garanta que a coluna 'cpf' exista no seu banco de dados!
        const res = await client.query('SELECT id, nome, cpf FROM clientes WHERE cpf = $1', [cpf]);
        
        if (res.rows.length === 0) {
            return { statusCode: 404, body: JSON.stringify({ erro: "Cliente não encontrado" }) };
        }

        const cliente = res.rows[0];

        // 4. Captura a Secret da variável de ambiente
        const secretText = process.env.JWT_SECRET || 'SuaChaveSecretaSuperForte12345678901234567890';
        
        // 5. Converte para Base64 para ser compatível com o Decoders.BASE64.decode() do Spring Boot
        const secretBase64 = Buffer.from(secretText, 'base64');

        // 6. Gera o JWT (Usando o identificador único no 'sub')
        const token = jwt.sign(
            { 
                sub: cliente.cpf, // O Spring Security costuma usar o subject para carregar o usuário
                id: cliente.id, 
                nome: cliente.nome,
                role: 'CLIENTE' 
            },
            secretBase64,
            { expiresIn: '2h' }
        );

        return {
            statusCode: 200,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ access_token: token })
        };

    } catch (err) {
        console.error("Erro na Lambda:", err); // Importante para debugar no CloudWatch da AWS
        return { statusCode: 500, body: JSON.stringify({ erro: "Erro interno no servidor de autenticação." }) };
    } finally {
        await client.end();
    }
};