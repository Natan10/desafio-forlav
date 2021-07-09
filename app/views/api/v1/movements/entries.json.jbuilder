json.entries do 
  json.array! @entries, partial: "/api/v1/movements/partials/entry", as: :entry
end