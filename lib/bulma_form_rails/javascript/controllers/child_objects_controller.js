import { Controller } from "@hotwired/stimulus"
import { put } from "@rails/request.js"

// Connects to data-controller="child-objects"
export default class extends Controller
{
  static targets = ["table"]
  static values =
      {
        name: String,
        attributesKey: String,
        url: String
      }

  addRow(event)
  {
    // Remove existing adder bar.
    const adderBarId = `${this.nameValue}-adder-bar`
    document.getElementById(adderBarId).remove()

    // Append new adder bar.
    const tbody = this.tableTarget
    
    let params = new URLSearchParams()
    params.append("name", this.nameValue)
    params.append("attributes_key", this.attributesKeyValue)
    params.append("size", tbody.childElementCount - 2)
    
    const new_row_url = `${this.urlValue}?${params}`
    put(new_row_url, {responseKind: "turbo_stream"})
  }
  
  deleteRow(event)
  {
    const tbody = this.tableTarget
    
    if (tbody.childElementCount > 3)
    {
      // Remove the specified row.
      const targetRowId = event.target.parentNode.parentNode.id;
      const rowIdName = this.nameFromId(targetRowId)
      const targetRowIndex = this.indexFromId(targetRowId)
      const targetRow = document.getElementById(targetRowId)
      targetRow.remove()
      
      // Renumber the remaining rows.
      for (let i = targetRowIndex + 1; i < tbody.children.length - 1; i++)
      {
        let row = tbody.children[i]
        let newRowIndex = i - 1
        row.id = `${rowIdName}[${newRowIndex}]`
        for (let cell of row.children)
        {
          for (let field of cell.children)
          {
            field.id = field.id.replace(`_${i}_`, `_${newRowIndex}_`)
            field.name = field.name.replace(`[${i}]`, `[${newRowIndex}]`)
          }
        }
      }
    }
  }
  
  nameFromId(id)  { return id.substring(0, id.indexOf("[")) }
  indexFromId(id) { return parseInt(id.slice(id.search(/\[\d+\]$/) + 1, -1)) }
}
