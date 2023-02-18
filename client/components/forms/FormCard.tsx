import React from "react";
import FormLabel from "./FormLabel";

interface FormCardProps {
  children: React.ReactNode;
  label: string;
}

const FormCard: React.FC<FormCardProps> = ({ children, label }) => {
  return (
    // <div
    //   className="flex w-auto flex-col items-center justify-center gap-6 rounded-2xl bg-cyan-200 p-4 shadow-sm shadow-cyan-400 md:w-[35rem]"
    //   {...props}
    // >
    <div className="flex w-auto flex-col items-center justify-center gap-6 rounded-2xl bg-cyan-200 p-4 shadow-sm shadow-cyan-400 md:w-[35rem]">
      <FormLabel className="text-3xl font-medium" value={label} />

      {/* Maybe abstract this to body */}
      {children}
    </div>
  );
};

export default FormCard;
