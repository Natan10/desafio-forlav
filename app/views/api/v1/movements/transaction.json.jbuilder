if @result.errors.empty?
  json.transaction do
    json.user @result.wallet.user.email
    json.balance @result.wallet.balance
    json.value @result.transaction.value
    json.status @result.transaction.status
  end
else
  json.errors @result.errors.first
end
