-- Remove o cliente de teste usado pra validar o site publicado (o Desafio Farol começa vazio).
-- Rodadas primeiro: rodada_pergunta aponta pra pergunta sem cascade.
delete from rodada where tenant_id in (select id from tenant where slug = 'teste-farol');
delete from tenant where slug = 'teste-farol';
