import React from "react";
import { Rubik } from "@next/font/google";

const font = Rubik({
  weight: "300",
  subsets: ["latin"],
});

interface FormLabelProps {
  value: string;
}

type OtherProps = React.DetailedHTMLProps<
  React.HTMLAttributes<HTMLDivElement>,
  HTMLDivElement
>;

const FormLabel: React.FC<FormLabelProps & OtherProps> = ({
  value,
  ...props
}) => {
  return (
    <div
      className={`${font.className} flex w-full justify-center border-b border-solid border-gray-400 p-2 text-center`}
    >
      <span {...props}>{value}</span>
    </div>
  );
};

export default FormLabel;
