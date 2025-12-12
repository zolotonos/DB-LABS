-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateTable
CREATE TABLE "address" (
    "address_id" UUID NOT NULL,
    "street" VARCHAR(255),
    "postal_code" VARCHAR(20),
    "customer_id" UUID,

    CONSTRAINT "address_pkey" PRIMARY KEY ("address_id")
);

-- CreateTable
CREATE TABLE "category" (
    "category_id" UUID NOT NULL,
    "name" VARCHAR(100),
    "description" TEXT,

    CONSTRAINT "category_pkey" PRIMARY KEY ("category_id")
);

-- CreateTable
CREATE TABLE "city_directory" (
    "postal_code" VARCHAR(20) NOT NULL,
    "city" VARCHAR(100) NOT NULL,
    "country" VARCHAR(100) NOT NULL,

    CONSTRAINT "city_directory_pkey" PRIMARY KEY ("postal_code")
);

-- CreateTable
CREATE TABLE "customer" (
    "customer_id" UUID NOT NULL,
    "first_name" VARCHAR(100),
    "last_name" VARCHAR(100),
    "email" VARCHAR(255),
    "phone" VARCHAR(50),

    CONSTRAINT "customer_pkey" PRIMARY KEY ("customer_id")
);

-- CreateTable
CREATE TABLE "order" (
    "order_id" UUID NOT NULL,
    "order_date" TIMESTAMP(6),
    "status" VARCHAR(50),
    "customer_id" UUID,
    "address_id" UUID,

    CONSTRAINT "order_pkey" PRIMARY KEY ("order_id")
);

-- CreateTable
CREATE TABLE "order_item" (
    "order_item_id" UUID NOT NULL,
    "quantity" INTEGER,
    "unit_price" DECIMAL(10,2),
    "order_id" UUID,
    "product_id" UUID,

    CONSTRAINT "order_item_pkey" PRIMARY KEY ("order_item_id")
);

-- CreateTable
CREATE TABLE "payment" (
    "payment_id" UUID NOT NULL,
    "amount" DECIMAL(10,2),
    "paid_at" TIMESTAMP(6),
    "order_id" UUID,
    "method_id" UUID NOT NULL,

    CONSTRAINT "payment_pkey" PRIMARY KEY ("payment_id")
);

-- CreateTable
CREATE TABLE "payment_method" (
    "method_id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "method_name" VARCHAR(50) NOT NULL,

    CONSTRAINT "payment_method_pkey" PRIMARY KEY ("method_id")
);

-- CreateTable
CREATE TABLE "product" (
    "product_id" UUID NOT NULL,
    "name" VARCHAR(150),
    "description" TEXT,
    "price" DECIMAL(10,2),
    "stock_quantity" INTEGER,
    "category_id" UUID,
    "supplier_id" UUID,

    CONSTRAINT "product_pkey" PRIMARY KEY ("product_id")
);

-- CreateTable
CREATE TABLE "supplier" (
    "supplier_id" UUID NOT NULL,
    "name" VARCHAR(150),
    "contact_email" VARCHAR(255),

    CONSTRAINT "supplier_pkey" PRIMARY KEY ("supplier_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "payment_method_method_name_key" ON "payment_method"("method_name");

-- AddForeignKey
ALTER TABLE "address" ADD CONSTRAINT "address_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "address" ADD CONSTRAINT "fk_address_city" FOREIGN KEY ("postal_code") REFERENCES "city_directory"("postal_code") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "address"("address_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("product_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "fk_payment_method" FOREIGN KEY ("method_id") REFERENCES "payment_method"("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "category"("category_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "supplier"("supplier_id") ON DELETE NO ACTION ON UPDATE NO ACTION;