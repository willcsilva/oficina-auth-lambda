const { Client } = require('pg');
const jwt = require('jsonwebtoken');

exports.handler = async (event) => {
    // 1. Extração do CPF (suportando chamadas via API Gateway ou direta)
    const body = typeof event.body === 'string' ? JSON.parse(event.body) : event.body;
    const cpf = body?.cpf?.replace(/\D/g, '');

    if (!cpf || cpf.length !== 11) {
        return { statusCode: 400, body: JSON.stringify({ erro: "CPF inválido" }) };
    }

    // 2. Configuração do Banco (Usando as envs que o LocalStack injetará)
    const client = new Client({
        host: process.env.DB_HOST || 'postgres-service',
        user: process.env.DB_USER || 'oficina_user',
        password: process.env.DB_PASSWORD || 'oficina_password',
        database: process.env.DB_NAME || 'oficinadb',
        port: 5432
    });

    try {
        await client.connect();
        
        // 3. Busca o cliente no banco da Oficina
        const res = await client.query('SELECT id, nome FROM cliente WHERE cpf = $1', [cpf]);
        
        if (res.rows.length === 0) {
            return { statusCode: 404, body: JSON.stringify({ erro: "Cliente não encontrado" }) };
        }

        // 4. Gera o JWT (Use a mesma secret que o Spring Boot usa para validar)
        const token = jwt.sign(
            { sub: res.rows[0].nome, id: res.rows[0].id, role: 'CLIENTE' },
            process.env.JWT_SECRET || 'minha-secret-segura',
            { expiresIn: '1h' }
        );

        return {
            statusCode: 200,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ access_token: token })
        };

    } catch (err) {
        return { statusCode: 500, body: JSON.stringify({ erro: err.message }) };
    } finally {
        await client.end();
    }
};
