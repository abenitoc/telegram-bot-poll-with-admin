require 'telegram_bot'

hash_respuesta = {}
encuesta_on = false
counter = 0
admin= "NAME OF ADMIN"
poll_text = "ASK YOUR QUESTION HERE"

#ASK BOT FATHER FOR THIS TOKEN
bot = TelegramBot.new(token: 'TOKEN HERE')
bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    case command
    when "/empieza"
      if message.from.username != nil && message.from.username == admin
        puts message.from.username
        reply.text = poll_text
      end
    when "/si"
      unless hash_respuesta.has_key?(message.from.id)
        hash_respuesta[message.from.id] = true
        if message.from.username != nil
          reply.text = "Guardada la opción de " + message.from.username
        else
          reply.text = "Guardada opción"
        end
      end
    when "/no"
        unless hash_respuesta.has_key?(message.from.id)
          hash_respuesta[message.from.id] = false
          if message.from.username != nil
            reply.text = "Guardada la opción de " + message.from.username
          else
            reply.text = "Guardada opción"
          end
        end

    when "/restart"
        if message.from.username != nil && message.from.username == admin
          hash_respuesta = {}
          reply.text = "Se reinicia la encuesta"
        end
    when "reset"
	if hash_respuesta.has_key?(message.from.id)
		hash_respuesta.delete(message.from.id)
	end
    when "/resultados"
      if message.from.username != nil && message.from.username == admin
        yes = 0
        no = 0
        hash_respuesta.each do |n|
          if n[1]
            yes = yes + 1
          else
            no = no + 1
          end
        end
        reply.text = "#{yes} personas están a favor, #{no} personas están en contra"
      end
    when "/help"
      reply.text = "Podéis votar utilizando /si o /no\ o /reset si queréis modificar vuestra opción. nEl resto de comandos solo están disponibles para el administrador."
    else
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
