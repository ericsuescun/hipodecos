# == Schema Information
#
# Table name: invoices
#
#  id           :bigint           not null, primary key
#  invoice_code :string
#  init_date    :date
#  final_date   :date
#  invoice_date :date
#  entity_id    :integer
#  inf_type     :string
#  value        :decimal(, )
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Invoice < ApplicationRecord
end
