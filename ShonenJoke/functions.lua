function shonen_joke.get_rank(id, card)
  local card_id = card and card.base.id or id
  local rank = nil
  if card_id == 14 then rank = "Ace"
  elseif card_id == 13 then rank = "King"
  elseif card_id == 12 then rank = "Queen"
  elseif card_id == 11 then rank = "Jack"
  else rank = ""..card_id end
  return rank
end

function shonen_joke.get_adjacent_jokers(card)
  local jokers = {}
  if #G.jokers.cards > 1 then
    local pos = 0
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i] == card then
        pos = i
        break
      end
    end
    if pos > 1 and G.jokers.cards[pos-1] then 
      table.insert(jokers, G.jokers.cards[pos-1])
    end
    if pos < #G.jokers.cards and G.jokers.cards[pos+1] then 
      table.insert(jokers, G.jokers.cards[pos+1])
    end
  end
  return jokers
end
