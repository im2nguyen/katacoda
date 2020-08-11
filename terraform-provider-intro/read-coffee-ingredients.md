## Read Coffee Ingredients

Add the following to your `main.tf`{{open}} file. This will retrieve ingredients for the first coffee from your order. The `data block` retrieves additional information about a resource, which enables it to be referenced by another Terraform resource. In this example, it's used by an `output` block to display the coffee ingredients.

<pre class="file" data-filename="main.tf" data-target="append">
data "hashicups_ingredients" "first_coffee" {
  coffee_id = hashicups_order.edu.items[0].coffee[0].id
}

output "first_coffee_ingredients" {
  value = data.hashicups_ingredients.first_coffee
}
</pre>

Run `terraform apply` to create the order. Notice how the execution plan shows a proposed order, with additional information about the order.

`terraform apply`{{execute T2}}

Remember to confirm the apply step with a `yes`{{execute T2}}.

Once the apply completes, you should see something similar to the following.

```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

first_coffee_ingredients = {
  "coffee_id" = 3
  "id" = "3"
  "ingredients" = [
    {
      "id" = 1
      "name" = "ingredient - Espresso"
      "quantity" = 20
      "unit" = "ml"
    },
    {
      "id" = 3
      "name" = "ingredient - Hot Water"
      "quantity" = 100
      "unit" = "ml"
    },
  ]
}
```

As you can see, ingredients of a Nomadicano is 20 ml espresso and 100 ml hot water.

### Verify order created

Verify the order was created by retrieving the order details via the API.

`curl -X GET  -H "Authorization: ${HASHICUPS_TOKEN}" localhost:19090/orders/1`{{execute T2}}

You should see something similar to the following:

```
{"id":1,"items":[{"coffee":{"id":3,"name":"Nomadicano","teaser":"Drink one today and you will want to schedule another","description":"","price":150,"image":"/nomad.png","ingredients":null},"quantity":2},{"coffee":{"id":2,"name":"Vaulatte","teaser":"Nothing gives you a safe and secure feeling like a Vaulatte","description":"","price":200,"image":"/vault.png","ingredients":null},"quantity":2}]}
```

The order's properties should be the same as that of your `hashicups_order.edu` resource.