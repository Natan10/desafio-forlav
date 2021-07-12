module ApplicationHelper
  def format_date(date)
    date.strftime("%d/%m/%Y")
  end

  def format_date_and_time(date)
    date.strftime("%d/%m/%Y %H:%M")
  end

  def flash_message(type)
    if(type == "notice" || type == "success")
      "Sucesso!"
    else  
       "Erro!"
    end
  end
end
