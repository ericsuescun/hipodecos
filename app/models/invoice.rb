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
  # Destroying an invoice "un-bills" the informs it stamped: their invoice
  # field is reset to "" (the billable/pending state the billing report looks
  # for) and invoice_date cleared, so a manager can undo a billing mistake and
  # re-invoice those informs. Scoped by invoice_code + entity_id + inf_type to
  # match exactly the rows ReportsController#invoice stamped.
  before_destroy :release_informs

  private

  def release_informs
    return if invoice_code.blank?

    Inform.where(invoice: invoice_code, entity_id: entity_id, inf_type: inf_type)
          .update_all(invoice: "", invoice_date: nil)
  end
end
