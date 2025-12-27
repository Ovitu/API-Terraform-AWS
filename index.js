const { Client } = require('pg');
const express = require('express');

(async () => {
    const app = express()
    // Porta 3000 definida no Terraform e no Dockerfile
    const port = process.env.API_PORT || 3000
    let i = 0

    app.listen(port, () => {
        console.log(`API iniciada. Escutando PORT ${port}`)
    })

    // Middleware para contar requisições
    app.use((req, res, next) => {
        i++;
        next();
    })

    // Rota inicial de teste
    app.get('/', async (req, res) => {
        const response = { 'message': "API OK!", 'request_id': i }
        console.log(response)
        res.send(response)
    })

    // ROTA DE CONEXÃO COM O BANCO DE DADOS
    app.get('/connect', async (req, res) => {
        try {
            const client = new Client({
                user: process.env.DB_USER,
                host: process.env.DB_HOST,
                database: process.env.DB_NAME,
                password: process.env.DB_PASSWORD,
                port: process.env.DB_PORT || 5432,
                // SSL é necessário para conexões seguras no RDS
                ssl: {
                    rejectUnauthorized: false
                }
            })
            
            await client.connect()

            // Executa uma query simples para testar a versão
            const result = await client.query('SELECT version()')
            const version = result.rows[0].version

            await client.end()

            const response = { 
                'message': "Conectado ao banco com sucesso!", 
                'version': version, 
                'request_id': i 
            }
            console.log(response)
            res.send(response)
            
        } catch (e) {
            const error = { 
                'message': 'Erro ao se conectar ao banco', 
                'detalhes': e.message,
                'request_id': i 
            }
            console.error(error)
            res.status(500).send(error)
        }
    })
})()
